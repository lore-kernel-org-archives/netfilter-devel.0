From: Phil Oester <kernel@linuxace.com>
Subject: Re: pptp conntrack fails on server call id != 0
Date: Fri, 4 Nov 2005 07:58:09 -0800
Message-ID: <20051104155809.GA21377@linuxace.com>
References: <b857c6de0511040032r75046c68s47a48b950f610191@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sadin Nurkic <sadin.nurkic@gmail.com>
Content-Disposition: inline
In-Reply-To: <b857c6de0511040032r75046c68s47a48b950f610191@mail.gmail.com>
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

On Fri, Nov 04, 2005 at 07:32:21PM +1100, Sadin Nurkic wrote:
> The correlation that I can see in the traces is that if the PPTP
> server call-id is set to 0 by the server, then the call would work.
> However if for some unknown reason this call-id is not set to 0, then
> the call (NAT-ing) does not occur so the call fails. It seems random
> that the call-id gets set to 0 on the server side, but I do see in the
> TCP trace that there is a correct call-id exchange in the control
> connection.

Did you check the mailing list archives?  I'll narrow it down: yesterday.

Phil
