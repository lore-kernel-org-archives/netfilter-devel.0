From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 14 Mar 2005 09:18:21 -0800
Message-ID: <20050314171821.GA29034@linuxace.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200503141647.42299.thomas.jarosch@intra2net.com>
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

On Mon, Mar 14, 2005 at 04:47:42PM +0100, Thomas Jarosch wrote:
> Hi,
> 
> I'm facing a problem with conntrack on a 2.4.21 kernel.
> One machine which firewalls a webradio reproducable
> becomes unresponsive every week with
> "ip_conntrack: table full, dropping packet."

When this happens, what does output from this look like:

wc -l /proc/net/ip_conntrack ; grep ip_conntrack /proc/slabinfo

Phil
