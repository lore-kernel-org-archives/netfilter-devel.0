From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: real close for 399 bug.
Date: Mon, 12 Dec 2005 08:22:50 +0100
Message-ID: <439D254A.7020703@trash.net>
References: <20051209213157.GA14708@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, alex@nrbspb.ru,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20051209213157.GA14708@2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> Hello, developers.
> I've just read bugzilla and found bug 399:
> 2.4 does not support connector, but I place define for that bit into
> header file to shut compiler up.
> It does not introduce any kind of regression, since 2.4 OSF version just
> do not use that bit.

Applied.
