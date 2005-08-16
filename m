From: Phil Oester <kernel@linuxace.com>
Subject: Re: Segmenation fault in netfilter/iptables code in 2.4.18 upon
	receiving a TFTP broadcast
Date: Tue, 16 Aug 2005 16:40:45 -0700
Message-ID: <20050816234045.GA4611@linuxace.com>
References: <00e001c5a2b4$431c0550$352310ac@nj.us.utstar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bala Pitchandi <bs@utstar.com>
Content-Disposition: inline
In-Reply-To: <00e001c5a2b4$431c0550$352310ac@nj.us.utstar.com>
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

On Tue, Aug 16, 2005 at 06:45:50PM -0400, Bala Pitchandi wrote:
> Hello,
> 
> I am using a 2.4.18 TimeSys kernel in a PPC device. Please see the
> attachment for the iptables rules that I have installed in my device. Newly
> installed Cisco routers send out TFTP broadcasts asking for configuration
> files (network-confg, cisconet.cfg etc) to get the hostname to IP address
> mapping. Upon receiving such a broadcast there was a SIGSEGV exception
> caused in the kernel. The call backtrace is given below:

Please upgrade to a recent kernel...the bug you are experiencing was
fixed long ago.

Phil
