From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: size of a rule
Date: Tue, 27 Apr 2004 11:41:30 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408E1CBA.5010007@aiqa.com>
References: <Pine.LNX.4.44.0404261609030.6443-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,  pangy2004@yahoo.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404261609030.6443-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org




Henrik Nordstrom wrote:

>
>ipt_entry->next_offset gives the size of this rule from what I can 
>understand.
>
>Regards
>Henrik
>
I solved my problem. Here is the sample which gets the name of target. 
It may be useful for other beginners.

Thank you for your help.

-------------------------------------------------
//print ipt_entry_target
struct ipt_entry_target *
get_target(const struct ipt_entry *e)
{
    return (void *)e + e->target_offset;
}

//print ipt_entry_target.name
static void print_target_name(const struct ipt_entry *e)
{
    struct ipt_entry_target *t = get_target(e);
    printf("Target name : %s\n", t->u.user.name);
}
------------------------------------------------------

-- 
Ozgur Akan
