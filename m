From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Re: RV: Problems loading a Patch-O-Matic match
Date: Wed, 19 Mar 2003 23:48:01 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303192348.01168.fabrice@netfilter.org>
References: <000101c2ed3a$67cf2530$0300000a@juan>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Juan Torres" <islero77@telefonica.net>,
   "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <000101c2ed3a$67cf2530$0300000a@juan>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Juan,

On Tuesday 18 March 2003 18:37, Juan Torres wrote:
> Hi, I'm trying to load a new match which comes in the Patch-O-Matic
> package. I have run Patch-O-Matic and I have selected the match I'm
> interested in (mport), then I have compiled the new kernel selecting in
> the xconfig the new option. But after all of these steps I can't use the
> new match. I have seen in the documentation that I have to go to the
> userspace/ directory (I suppose that it is the "userspace" directory
> into the Patch-O-Matic package)

nope, that is the userspace directory of iptables distribution.
Userspace directory of p-o-m doesn't contain any makefile ;-)

So just download the latest tarball of iptables. Of if you follow
the document to the letter, you would be using CVS version which would
be layed out properly for you already :)

> and execute make all install, but, when
> I do that the response is the next
> make: *** No rule to make target 'all'. Stop.

no makefile, see above.

> If I try to use the new match (for example, if I write iptables -A INPUT
> -p tcp -m mport --ports 20:23,80 -j DROP)
> the answer that I receive is:
> iptables v1.2.5: Couldn't load match
> `mport':/usr/lib/iptables/libipt_mport.so: cannot open shared object
> file: No such file or directory
> There are two mport files that are created:
>    /usr /src/linux-2.4.18.SuSE/include/config/ip/nf/match/mport/module.h
> and
    /lib/modules/2.4.18-64GB-SMP/kernel/net/ipv4/netfilter/ipt_mport.o
> but it doesn't exist the libipt_mport.so file.
> Can anybody tell me what it's my problem?
> Thank you very much.

As explained above, just grab the latest iptables tarball and recompile
from the userspace directory there (not the one of patch-o-matic).
I recommend you to use the CVS version, or a recent snapshot.

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
