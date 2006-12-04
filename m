From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables 1.3.6 compilation issues in libipt_iprange.c
 (non-existant __be32 type)
Date: Mon, 04 Dec 2006 18:47:58 +0100
Message-ID: <45745F4E.1010503@trash.net>
References: <20061204154845.GA21750@ekonomika.be> <45744680.5080702@trash.net>
	<20061204165250.GA1730@ekonomika.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kulnet@kulnet.kuleuven.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Steven Van Acker <deepstar@singularity.be>
In-Reply-To: <20061204165250.GA1730@ekonomika.be>
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
> 1.3.7 compiles and works nicely with a 2.6.19 kernel on my system.
> Thanks :)
> 
> I'm still wondering why <linux/types.h> is not used though. Is it to
> avoid complications with older kernels ?

Main reason is because I didn't think of it :) But I don't see an
advantage in changing it again.
