From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] ipt_time support for 2.6.21
Date: Thu, 26 Apr 2007 17:04:17 +0200
Message-ID: <200704261704.18172.thomas.jarosch@intra2net.com>
References: <200704261414.33473.thomas.jarosch@intra2net.com>
	<Pine.LNX.4.61.0704261653150.506@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Fabrice MARIE <fabrice@netfilter.org>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0704261653150.506@yvahk01.tjqt.qr>
Content-Disposition: inline
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

Hello Jan,

On Thursday, 26. April 2007, Jan Engelhardt wrote:
> On Apr 26 2007 14:14, Thomas Jarosch wrote:
> >attached is a patch to add kernel 2.6.21 support to ipt_time.
>
> See http://lists.netfilter.org/pipermail/netfilter/2007-April/068388.html

Sorry, must have missed that and it's still
unpatched in the pom download repository.

Though I prefer my patch as ipt_time continues to work with "older" 2.6.x 
versions like 2.6.20. There is already an #ifdef for the matchsize,
so why break it now...

Cheers,
Thomas
