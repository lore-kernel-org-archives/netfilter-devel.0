From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 00:45:41 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403190042550.32344-100000@filer.marasystems.com>
References: <40599AC4.6030504@nk.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <40599AC4.6030504@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 18 Mar 2004, Victor Julien wrote:

> using 'iptables-restore' (without noflush) is there a way to preserve 
> the accounting data from the first rule?

Then you must use incremental commands, keepint the accounting rule 
untouched.

> Is this what the -c option of iptables-restore is for?

No. This instructs iptables-restore to restore any packet/byte counters 
found in the input data. Without this option any such counters is ignored 
and the installed rules have zeroed counters.

Regards
Henrik
