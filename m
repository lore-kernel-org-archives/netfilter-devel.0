From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch-o-matic-ng questions and remarks from newbie
Date: Mon, 15 Nov 2004 23:23:10 +0100
Message-ID: <41992C4E.2050809@trash.net>
References: <20041107102832.463003a4@localhost>	<418E8EB7.8050604@trash.net>
	<20041115141326.4ced89bc@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Johannes Graumann <graumann@caltech.edu>
In-Reply-To: <20041115141326.4ced89bc@localhost>
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

Johannes Graumann wrote:

>Thanks,
>
>I found those and have finally managed to get my kernel to compile.
>One general question of mine remains unsolved: is there - aside from
>trial and error - some way to figure out which patch in the
>patch-o-matic-ng plays well with what kernel?
>
They should have dependencies that are automatically checked,
but usually something like "kernel >= 2.6.7 is used", this of
course doesn't catch future versions that the patch won't work
with anymore.

Regards
Patrick
