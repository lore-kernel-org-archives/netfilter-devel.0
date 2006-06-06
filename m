From: Philip Craig <philipc@snapgear.com>
Subject: Re: POSTROUTING hooks
Date: Tue, 06 Jun 2006 17:21:37 +1000
Message-ID: <44852D01.3010206@snapgear.com>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255456@xavier.staff.greatlakes.net>
	<20060606063723.GH8333@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>, "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
In-Reply-To: <20060606063723.GH8333@oknodo.bof.de>
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

On 06/06/2006 04:37 PM, Patrick Schaaf wrote:
>> I don't ever recall seeing destination MAC matching support. Do you know
>> what version of the code this was in?
> 
> Hmm. Google fails me. Maybe my memory completely failed me... Help, anybody? :)

I found lots of talk about iptables dst mac matches, but no code.

ebtables can match on destination MAC.  This means you have to create
a dummy bridge though, which slows things down.

Another option is to create static arp entries, and then just filter
by IP address.
