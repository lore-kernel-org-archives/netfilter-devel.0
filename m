From: Phil Oester <kernel@linuxace.com>
Subject: Re: System with really big statetable crashing while doing "cat /proc/net/ip_conntrack | wc -l"
Date: Thu, 22 Apr 2004 15:59:35 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040422225935.GA8942@linuxace.com>
References: <40875ECE.1000405@rz.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jens Hektor <hektor@rz.rwth-aachen.de>
Content-Disposition: inline
In-Reply-To: <40875ECE.1000405@rz.rwth-aachen.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, this is a known bug.  I submitted a patch to fix it a few days ago
but have not heard anything from core developers.  See archives:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-April/015054.html

Phil Oester


On Thu, Apr 22, 2004 at 07:57:34AM +0200, Jens Hektor wrote:
> So we only can guess for if doing
> 
> 	cat /proc/net/ip_conntrack | wc -l
> 
> the system reproducably crashes.
