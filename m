From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: Fw: segmentation fault with proc cleanup + CLUSTERIP
Date: Mon, 11 Jul 2005 10:05:02 +1000
Message-ID: <0ed001c585ac$2f344130$5001010a@bluereef.local>
References: <0e9e01c5850a$1f7b5230$5001010a@bluereef.local>
	<20050710141443.GI20465@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Harald Welte" <laforge@netfilter.org>
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

>So what kind of userspace application are you using?  How frequently is
>that entry read?

----- Original Message ----- 
From: "Harald Welte" <laforge@netfilter.org>
To: "Andrew Hall" <temp02@bluereef.com.au>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Monday, July 11, 2005 12:14 AM
Subject: Re: Fw: segmentation fault with proc cleanup + CLUSTERIP

I haven't written the userspace app to read the proc value yet and it's not 
being manually read at the time when this happens. I'm not sure why it only 
occurs intermittently but it would seem that some reference is being 
actively used or has been deleted when destroy is called. 
