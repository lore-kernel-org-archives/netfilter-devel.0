From: Patrick McHardy <kaber@trash.net>
Subject: Re: rtsp-conntrack without needing NAT
Date: Fri, 15 Sep 2006 06:40:12 +0200
Message-ID: <450A2EAC.8030701@trash.net>
References: <20060914125154.GA4620@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Mickael Marchand <marchand@kde.org>, kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
In-Reply-To: <20060914125154.GA4620@ekonomika.be>
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

Steven Van Acker wrote:
> Hi,
> 
> the rtsp-conntrack patch I found at
> http://www.freenux.org/~mm/rtsp/2.6.15-rtsp.patch applies nicely to the
> kernels I compile with Full NAT support, but not without.
> 
> This is caused by calls to NAT functions from within ip_conntrack_rtsp.c
> 
> For the past couple days, I've tried to make sense of connectiontracking
> and NAT code and I believe my version of the patch should fix the
> problem.
> 
> I've compiled it without problems, and the modules load.
> But since I've never really messed with kernel code before, I don't know
> if I broke anything or introduced bugs anywhere.
> 
> Maybe someone with more experience can look over the patch and see if it
> makes sense ?

You're more likely to find someone if you post your changes as a patch
to the original version.
