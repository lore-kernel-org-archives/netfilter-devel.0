From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Mon, 11 Apr 2005 15:30:46 +0200
Message-ID: <425A7C06.9040600@gmx.net>
References: <200504050948.51387.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200504050948.51387.thomas.jarosch@intra2net.com>
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

Hi Thomas,

Thomas Jarosch schrieb:
> 
> attached is a patch to fix the ACCOUNT target for large networks.
> This time for good ;-) Discard the patch I sent yesterday.
> 
> It runs stable now on a network with ~1300 active clients. Quoting the user:
> "Nevertheless, from performance point of view, ipt_ACCOUNT rocks. I have a
> distribution for routers (Route Hat) and last night switched from ipt_account
> to ipt_ACCOUNT completely. What took half a minute before now takes 300ms
> i.e. 100 times faster, same router, same net. Gr8 work :-)"

When reading the source, it seems to me that ACCOUNT has some room
for improvement:

- It is handling some sparsely populated networks inefficiently.
Consider e.g. a 192.168/16 network with 512 clients spread over
the whole range like 192.168.0.10,192.168.0.25,192.168.1.12 etc.
This needs as much memory as a fully populated network of the same
size.
- It can only handle /8,/16 and /24 networks.
- It can't account based on MAC or MAC/IP.
- It is impossible to select what is accounted for (packets/bytes,
in/out) and what should be added to the counters (layer 2 frame
length, layer 3 packet length...).

Oh, and I'd like to run the code on a 64bit machine with a 2.6 kernel.

Do you accept patches for the above items or are they already done/
being worked on by somebody else?


Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
