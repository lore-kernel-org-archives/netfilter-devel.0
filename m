From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: re: conntrack hash function comparison
Date: Mon, 20 Jan 2003 22:19:55 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15916.59019.853598.788888@isis.cs3-inc.com>
References: <20030120232634.24011.21218.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030120232634.24011.21218.Mailman@kashyyyk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 > Please look trough the web pages and comment it.

I see several hash functions have been added since I last looked.
Aftr some search I see the code in http://bei.bof.de/
(I suggest a reference to it from the advertised page.)
This code looks a bit old.  Below is the version I'm using at
present.  I suggest you try testing this version too.
I expect it will be a little slower (using long numbers) but
a little better, for instance, on table sizes that are powers of 2.
Note A,B,C,D are in this code coef[0..3].  As described below these
are randomly chosen at initialization.  
Hmm, I notice I've lost proto.  The code below was meant for only
one protocol.  It should be ok to add key->proto to sum below.
====
static u32 flowhash (struct flowdesc *key)
{
  unsigned long long ls, ld, lp;
  unsigned long sum;
  ls = (unsigned long long) key->saddr * coef[0];
  ld = (unsigned long long) key->daddr * coef[1];
  lp = (unsigned long long) coef[2] *
    (u32)((u32)(key->source << 16) + key->dest);
  sum =
    ((ls ^ (ls >> 32)) +
     (ld ^ (ld >> 32)) +
     (lp ^ (lp >> 32))) ^ coef[3];
  return sum % flow_ht_size;
}
====

A few details:
- The ABCD(EF) algorithms were actually suggested to me by Rich
Schroeppel. 
- I don't see what you consider odd about the random results.
- I think the discussion on this list last summer contained an
analysis of what we should expect from the random hash function.

And now the important point:
Besides performance, ABCD(EF) was designed to satisfy another goal:
it is supposed to be difficult to attack.  In particular, an attacker
might try to cause you to spend lots of time in your hash function by
arranging to send lots of packets that generate connections that all
hash to the same bucket.  If he knows your algorithm, including all
of the relevant constants, this is pretty easy.  The original hash
algorithm, of course, poses no challenge to such an attacker.  
It turns out (as was discussed on the mailing list last summer) that
CRC is also easy to attack.  I don't know about the hash functions
that have shown up more recently, of course.
The idea behind ABCD(EF) is that the coefficients A,B,C,D(,E,F) are
secrets, chosen randomly by each connection tracking machine.
So far I don't know how this can be attacked.  My current code assumes
that, if it can be attacked at all, this will at least take a long
time.  The solution is that (1) I detect that the current coeffecients
are not working as well as expected (simply that some bucket gets
filled past a very unlikely threshold), and in that case (2) we choose
new randome coeffecients and rehash everything (which probably takes
less than a second unless you have millions of connections).
