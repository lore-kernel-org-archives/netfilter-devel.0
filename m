From: Octavio / Super <alvarezp@octavio.ods.org>
Subject: Re: MSN helper module
Date: Tue, 17 Dec 2002 19:46:53 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.0.20021217193634.03065cd8@192.168.0.1>
References: <200212171647.gBHGkxmD003537@sandelman.ottawa.on.ca>
 <002801c2a5fb$1eb92660$152ea8c0@maincomp>
 <1040161933.615.71.camel@exile>
 <001701c2a615$cc774dd0$152ea8c0@maincomp>
 <1040164701.893.42.camel@exile>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Carlos Fernandez Sanz" <cfs-netfilter@nisupu.com>
In-Reply-To: <002201c2a630$5c460950$152ea8c0@maincomp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Carlos:

Bauke Fahner and I started working on something, but couldn't get much actually done.

At 01:56 a.m. 18/12/2002 +0100, Carlos Fernandez Sanz wrote:
>Filip,
>
>I need to check the protocol specs (and even more important, I need to see
>some actual data flow) a bit more in detail before getting into any deep
>discussion, but I believe it's better to focus on a working implementation
>and then tight the security with all the checks that might be needed.

I completely agree with that.

>I'm reading some docs and they say that for a file transfer to take place,
>you need to send an invitation message over a switchboard session. It
>doesn't say whether such a session can be an existing one or not, the
>example opens one so I can't really tell.

I don't actually think it should be that difficult. The thing is that I haven't understood some part of the Netfilter documentation, but here is my opinion.

With the current implementation of MSNP and Netfilter, you only need to do conntrack and nat for outgoing file transfers.

Since in the current protocol implementation, switchboard sessions will always be opened on port 1863, my idea is to capture this port and start the connection tracking from here.

As for NAT, we should only need to do the same thing: Accepted packets should be analyzed and checked to see whether the packet is asking the client for information, and, on the reply packet change the port number and IP address accordingly (and update the rest of the packet accordingly, also).

>BTW...and I'm saying this without careful documentation reading...the
>protocol seems 'secure enough' :-)
>
>Anyway, if you are up for a challenge, I'll let you know as soon as I have
>something working and you can have some fun trying to break it :-)

I'm in. I have the rest of December and the whole January.

Octavio.
---
/**************************************************
Octavio Alvarez (aka: Super, Doogie)
ICQ# 42020731. MSN_ID: alvarezp2000@h0tmail.com
**************************************************/
