From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Mon, 1 Jul 2002 14:30:39 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15648.51711.918456.294773@isis.cs3-inc.com>
References: <20020701121404.B78724512@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org, bof@bof.de
In-Reply-To: <20020701121404.B78724512@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Patrick Schaaf writes:
 >  > You can now use '-c NUMBER' to set a seed for the CRC32 hash. You can now
 >  > use '-C' (without parameter) to set a random seed for the CRC32 hash.
 >  > These options are for testing the idea of "attack compensation by
 >  > inserting local variance". I'd like to hear opinions on this.

 > At a higher level, though, I don't see much value in preventing an
 > attacker from filling a single bucket when he can almost as easily do
 > much more harm by filling the entire conntrack database!

On the other hand, if we do have a way to prevent an attacker from
filling the conntrack database, this does become interesting again.
Assuming, of course, the attacker can't skew the crc hash results by
feeding you particular data without knowing your seed.  I still hope
to hear from some experts out there on this subject.

And now, since I think this is a useful approach it's worth while to
mention the following:

  static u32 hash_crc32(struct ct_key *key)
  {
	  u32 crc = crc32_seed;
	  u32 v32;
	  u16 v16;
	  crc = crc32(crc, (const char *) &key->proto, sizeof(key->proto));
	  v32 = ntohl(key->sip);
	  crc = crc32(crc, (const char *) &v32, sizeof(v32));
	  v32 = ntohl(key->dip);
	  crc = crc32(crc, (const char *) &v32, sizeof(v32));
	  v16 = ntohs(key->sport);
	  crc = crc32(crc, (const char *) &v16, sizeof(v16));
	  v16 = ntohs(key->dport);
	  crc = crc32(crc, (const char *) &v16, sizeof(v16));
	  return crc;
  }

Isn't that the same (modulo order of data) as this?
     return crc32(crc, (const char *) key, sizeof(struct ct_key)); 

On my 200MHz machine
 your crc    my change	hash_conntrack
 1.5usec     1.1usec    .2usec		   gcc -o cttest cttest.c
 1.1usec     .53usec    .14usec		   gcc -O9 -o cttest cttest.c
