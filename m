From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/09]: Netfilter update
Date: Tue, 21 Mar 2006 03:18:40 +0100
Message-ID: <441F6280.3020201@trash.net>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
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

Patrick McHardy wrote:
> Hi Dave,
> 
> following are my pending netfilter patches for 2.6.17, most notable is
> a very nice and clean H.323 connection tracking helper by Jing Min Zhao.
> Please apply.

Dave, I'm sorry for the annoyance, but please drop the entire patchset
except for the H.323 helper. Something is messing up ip6tables on
one of my systems and the only thing I'm sure of is that its not the
H.323 helper :)

I'll resubmit the remaining patches once I know whats going on.
