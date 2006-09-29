From: Patrick McHardy <kaber@trash.net>
Subject: Re: What basic sanity checking on packet headers is done
Date: Fri, 29 Sep 2006 19:14:27 +0200
Message-ID: <451D5473.7020908@trash.net>
References: <451D47E5.7000108@positivenetworks.net>
	<451D4EB9.2020905@trash.net>
	<451D50F6.5020709@positivenetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wayne Schroeder <raz@positivenetworks.net>
In-Reply-To: <451D50F6.5020709@positivenetworks.net>
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

Wayne Schroeder wrote:
> Sounds like somone as root on the local machine could make packets that
> would pop the kernel if the conditions were right, but everything else,
> specifically remote traffic, will be safe to trust ihl and tot_len on?
> If that's the case, then I'm in the clear.

Right. I didn't find any problematic cases by doing a quick grep,
but I guess its worth going over everything to make sure.
With things like OpenVZ even "root might crash the machine" is
a problem.
