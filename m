From: Milos Wimmer <wimmer@zcu.cz>
Subject: Re: 2.6.11 corrupting FTP session
Date: Sat, 2 Apr 2005 21:31:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504022105520.19574@nike.zcu.cz>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
	<1111341503.423db9bfcffb7@webmail.conectcor.com.br>
	<20050401060249.GI19835@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050401060249.GI19835@sunbeam.de.gnumonks.org>
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

On Fri, 1 Apr 2005, Harald Welte wrote:

> this sounds pretty straight forward, still i can't reproduce the problem
> at all. which ftp server and client are you using?

  I have same problem (see Bug #308).

  I'm using command line ftp client on Linux machines and command line ftp 
client on Windows XP.
And any of ftp serveres which I tried (e.g. 
ftp://ftp.zcu.cz/pub/doc/rfc/, 
ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/,
ftp.cesnet.cz,  ...)

I'm using Linux firewalls with shorewall package on many sites and I 
found this problem on any of them.


For simplification - I build test configuration with 1 firewall box and 1
client box on my office now. Firewall has 2 interfaces - one to Internet,
second to local network - client. Client box is connected to firewall with
crosswired twisted pair cable.
Client uses no iptables and when it is connected to Internet, it transfers
all files via active ftp session without problems.

On the firewall I use vanilla Shorewall (2.x.x) configuration with
"loc    net     ACCEPT"  global policy, no any other specialities.

When I'm running kernel 2.4.x and 2.6.0-2.6.10 kernel on the firewall,
active ftp session on the client works fine. When I'm running 2.6.11,
2.6.11.x and 2.6.12-rc1 kernel on the firewall box, active ftp session
with "mget *" command fails after 6 transfered files.
Passive ftp session works fine on any kernel.

I used vanilla kernel without patches (I could send you my kernel config 
file).

        Milos Wimmer
