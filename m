From: Patrick McHardy <kaber@trash.net>
Subject: Re: H.225 RAS (gatekeepers) support
Date: Thu, 08 Sep 2005 16:49:49 +0200
Message-ID: <43204F8D.5020403@trash.net>
References: <a8a372c050908074126ea930a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Oscar Mateo <omateo@gmail.com>
In-Reply-To: <a8a372c050908074126ea930a@mail.gmail.com>
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

Oscar Mateo wrote:
> Hi,
> 
> This question goes for H323 NAT/Conntrack modules users/developers:
> Iis there any plan to support H.225 RAS signalling (gatekeepers)? If
> so, when (approximately) will it be ready?

I have a version of the H323 helper with GK support, but so far it only
parses all messages, issuing expectations isn't done yet. There are
a number of hard problems, I hope we can solve them at the netfilter
workshop next month.
