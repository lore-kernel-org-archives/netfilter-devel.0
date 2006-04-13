From: Sebastien Tandel <standel@info.ucl.ac.be>
Subject: Re: iptables doubt
Date: Thu, 13 Apr 2006 12:14:28 +0200
Message-ID: <443E2484.6020301@info.ucl.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,
varun wrote:
> Hi all,
>
>             Iam new to netfilters and iam trying to play around to
> understand a few things. By default when no policies are specified then
> it allows all traffic to go out and in to the n/w. I want to change this
> to default as deny.
>             That is when there is no policy all should be default deny.
>
>           So in order to achieve that i tried to change the  code a little.
>            In the file iptable_filter.c there is a variable called
> static int forward = NF_ACCEPT
>             I changed this to NF_DROP and when i compiled and used it
> sure i was not able to send any or recv any packets
I think you made the right change in your code in order to have a DROP
policy by default in your netfilter. the problem is just after ...

>             but even after i give a policy like iptables -t filter -A
> INPUT -j ACCEPT
>             Nothing changes. So achieve what i want what should i do?
> And where do i change?

It is quiet normal as you told netfilter to accept incoming packets but
you did not configure netfilter to accept *outgoing* packets ...
iptables -t filter -A OUTPUT -j ACCEPT

>
>             Another thing is that in normally when i put a policy like
> iptables -t filter -A OUTPUT -j REJECT
>              Even my own self IP doesnt ping? Why should this happen?
>               Isint it ok to ping local ip and loopback ip?
>                If i want such implementation where i should be able to
> ping to self and local but not any other ip?
>                Is it possible?

lo is the interface allotted to your local interface (i.e. your host)!
You must therefore create two rules in order to let netfilter accept
outgoing and incoming packets from and arriving to your local interface.
iptables -A INPOUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT


>                I dont want to add policies rather is it possible just by
> changing the iptables kernel code?

You have to initialize netfilter by adding two static rules implementing
the ones described here above.

sta
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFEPiSEw76McB8jGxkRAhzNAJoCC6FwR6PvmEJG8IzNXeod29u8jQCdFPY7
N9fguzx+i6R9s+sCpz+AHfc=
=120L
-----END PGP SIGNATURE-----
