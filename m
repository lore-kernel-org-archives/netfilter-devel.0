From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 13:00:40 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207071300.40861@henrik.marasystems.com>
References: <20020706224109.GH3729@aaricia.hemmet.chalmers.se> <20020707042341.GK3729@aaricia.hemmet.chalmers.se> <20020707054607.GL3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson),
	netfilter-devel@lists.samba.org
In-Reply-To: <20020707054607.GL3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sunday 07 July 2002 07.46, Joakim Axelsson wrote:
> res = ((key->sip & 0xF0F0F0F0) >> 4) | ((key->sip & 0x0F0F0F0F) <<
> 4); res *= 0x47441DFB;
> res ^= key->dip ^ key->proto;
> res ^= ((key->dport << 16) | key->sport);
> res ^= 0x57655A7D;
> res ^= (res >> 24);
> res ^= (res >> 8);
>
>
> Now someone else have to take a look at it. I digged my head into a
> corner.

Hmm...

> res ^= key->dip ^ key->proto;
> res ^= ((key->dport << 16) | key->sport);

can easily nullify itself.. here you are just xor:ing the destination 
IP with the source and destination ports, which makes a highly 
predictable hash pattern..

To always hit the same hash bucket you just need to keep the source IP 
constant, and the result of the above XOR constant..

> res ^= 0x57655A7D;
> res ^= (res >> 24);
> res ^= (res >> 8);

And this is twofold.. it both obfuscates the bits and probably makes 
it likelier an attacker can find bits that nullify eachother, 
especially so if the hash size is not prime (or at a minimum odd).. 
These 5 xor statements xor:s quite many sources into the lower bits, 
always in the same order.. I am pretty sure you will find very 
interesting iterference patterns if you unwind these xors.

Regards
Henrik
