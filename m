From: Philip Craig <philipc@snapgear.com>
Subject: Re: condition and 2.6
Date: Mon, 01 Mar 2004 17:40:40 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4042E8F8.5040702@snapgear.com>
References: <200402290210.35962.lists@egidy.de> <200402291528.01679.lists@egidy.de> <20040229205626.GN15558@sunbeam.de.gnumonks.org> <200402292314.03863.lists@egidy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gerd@egidy.de
In-Reply-To: <200402292314.03863.lists@egidy.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Gerd v. Egidy wrote:
> I think of a lockfile (e.g. /var/run/libiptc.pid) which is created by the 
> library in iptc_init and removed in iptc_commit. This way all programs using 
> libiptc become safe at once.

This is not good enough, since iptc_init and iptc_commit are per table.

You could fix that by adding iptc_lock and iptc_unlock functions to libiptc.
This would work for iptables-save/restore, but it will still not help if
you are using multiple iptables commands to modify your rules.

The lock operations really need to be around your entire script, which
means you can't implement them in libiptc or the iptables commands.

-- 
Philip Craig - SnapGear, A CyberGuard Company - http://www.SnapGear.com
