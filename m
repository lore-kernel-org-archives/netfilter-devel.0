From: Phil Oester <kernel@linuxace.com>
Subject: Re: Segmenation fault in netfilter/iptables code in 2.4.18 upon
	receiving a TFTP broadcast
Date: Tue, 16 Aug 2005 17:18:08 -0700
Message-ID: <20050817001808.GA5323@linuxace.com>
References: <20050816234045.GA4611@linuxace.com>
	<00ee01c5a2be$eb4c0180$352310ac@nj.us.utstar.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bala Pitchandi <bs@utstar.com>
Content-Disposition: inline
In-Reply-To: <00ee01c5a2be$eb4c0180$352310ac@nj.us.utstar.com>
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

On Tue, Aug 16, 2005 at 08:02:07PM -0400, Bala Pitchandi wrote:
> Phil,
> 
> Thanks for your response. I kinda knew that this bug has been fixed in the
> later version of the kernel.

good

> Since the kernel that I am using is a modified version of the 2.4.18 kernel,
> it would be too much of an hassle for me to update the entire kernel. If you
> could point me to the version of the kernel where this bug was fixed, I
> could just port this fix onto my netfilter/iptables.

a searchable archive of the netfilter-devel list is available here:

http://marc.theaimsgroup.com/?l=netfilter-devel&r=1&w=2

searching for 'tftp oops' will give you the answer on result 10 of 17.

Phil
