From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Re: Delition of rule after altering data in check/match entry
Date: Wed, 16 Jul 2003 13:57:57 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00a201c34b74$29540e90$010f430a@elitecore7>
References: <02b201c34a1c$faef6ac0$010f430a@elitecore7> <20030715122846.GH7198@naboo>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,
    Thanks for reply. I'm sorry that without thorough study of nice document
netfilter-hacking-HOWTO I posted this as a problem. I seen ipt_limit as
reference and problem fixed.

static
struct iptables_match problem_foo = {
        NULL,
        "foo",
        NETFILTER_VERSION,
        IPT_ALIGN(sizeof(struct ipt_foo_target_info)),
        IPT_ALIGN(sizeof(struct ipt_foo_target_info) - sizeof(struct
__kern_set)),
        &help,
        &init,
        &parse,
        &final,
        &print,
        &save,
        opts
};
static
struct iptables_match right_foo = {
        NULL,
        "foo",
        NETFILTER_VERSION,
        IPT_ALIGN(sizeof(struct ipt_foo_target_info)),
        offsetof(struct ipt_foo_target_info, kern_set),
        &help,
        &init,
        &parse,
        &final,
        &print,
        &save,
        opts
};

----- Original Message -----
From: "Harald Welte" <laforge@netfilter.org>
Sent: Tuesday, July 15, 2003 5:58 PM

On Mon, Jul 14, 2003 at 09:01:22PM +0530, Sumit Pandya wrote:
> Hi All,
>     In a netfilter match or check extension at the time of rule-insertion,
> If I update any data passed along
>     1> void *matchinfo (argument to matchentry) or
>     2> void *targinfo  (argument to checkentry)
> Then I'm not able to delete same inserted rule.
>     Is there something regarding caching of the data? Does It require to
> notify iptables somewhere about this change?

Just at first glance, I think this is quite possible (and certainly not
the desired behaviour).   Can you please verify that this bug is also
present with already-existing matches/targets that change
targinfo/matchinfo contents (like the nth or random match)?
