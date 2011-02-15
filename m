From: Patrick McHardy <kaber@trash.net>
Subject: Re: H.225.0 "Connect" packet dropped (fwd)
Date: Tue, 15 Feb 2011 11:12:25 +0100
Message-ID: <4D5A5189.6000409@trash.net>
References: <alpine.DEB.2.00.1102141617200.26009@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jobhunts02@aol.com
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39085 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1BOKMu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Feb 2011 05:12:50 -0500
In-Reply-To: <alpine.DEB.2.00.1102141617200.26009@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 14.02.2011 16:18, Jozsef Kadlecsik wrote:
> Here is my network topology:
>  
>             +-----------+
>             |  camera   |
>             |10.175.1.6 |
>             +-----------+
>                   |
>                   |
> +--------------+  |  +----------------------+                 +----------------------+      +--------------+ 
> |     PC1      |  |  |      Linux Box1      |                 |      Linux Box2      |      |     PC2      | 
> |  10.175.1.3  |<--->|10.175.1.1  10.0.1.220|~~~ Satellite ~~~|10.0.1.219  10.175.2.1|<---->|  10.175.2.2  |
> |              |     |eth0              sat0|      Link       |sat0              eth0|      |              | 
> +--------------+     +----------------------+                 +----------------------+      +--------------+ 
>  
>  
> I am trying to send video from the camera to PC2.  The attached pcap files were from Linux Box2, which is where the 
> Connect message from PC2 to the camera gets dropped.  As you can see in eth0.pcap, the Connect message from PC2 to 
> the camera is there, but it is not in sat0.pcap.  Since no Connect message gets to the camera, the video stream never starts.
>  
>  
> While doing the capture, I also got numerous "Invalid truesize" warnings.  If I do not do a capture, I do not see these warnings.  If I disable SCPS, I do not see these warnings either, whether or not I am doing a capture.
>  
>  
>  
> Feb 11 21:44:54 (none) user.info kernel: device eth0 entered promiscuous mode
> Feb 11 21:45:05 (none) user.info kernel: device sat0 entered promiscuous mode
> Feb 11 21:45:52 (none) user.err kernel: SKB BUG: Invalid truesize (240) len=78, sizeof(sk_buff)=176

Something is obviously broken. Is SCPS implemented as a kernel
module?
