From: Craig Davison <cd@securityfocus.com>
Subject: Re: iptc_delete_entry or iptc_delete_num_entry?
Date: Sun, 2 Feb 2003 13:27:02 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030202202702.GB28811@securityfocus.com>
References: <20030131023009.GB15989@securityfocus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030131023009.GB15989@securityfocus.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi again,

The reason I'm asking is that neither the LDP nor the Netfilter Hacking HOWTO have adequate
information on these functions. Basically I need help from someone who has used libiptc to
add, modify and delete rules, or at least some kind of document on the subject.

On Thu, Jan 30, 2003 at 07:30:09PM -0700, Craig Davison wrote:
> Hi,
> 
> Should I be using iptc_delete_num_entry or iptc_delete_entry to delete 
> rules from a chain? I can't seem to find documentation for the 
> parameters of iptc_delete_entry (please point me in the right direction if 
> it exists!), and I'm not 100% sure what to pass for the rulenum parameter 
> to iptc_delete_num_entry.
> 
> The only documentation I have for iptc_delete_num_entry is the 
> Querying-libiptc-HOWTO from the LDP, and it says that rulenum is a rule 
> number starting at 1 for the first rule.
> 
> So let's say I want to delete every rule one at a time from a chain. Do I 
> have to manually increase my own rulenum counter for every rule, or is 
> there some way to get rulenum from an ipt_entry?
> 
> Example:
> 
> iptc_handle_t htable;
> const char *chain = "INPUT";
> struct ipt_entry *entry;
> int rulenum = 0, is_chain_changed = 0;
> 
> if (!(htable = iptc_init ("filter")))
> {
>   printf ("iptc_init: %s\n", iptc_strerror (errno));
>   exit(0);
> }
> 
> entry = (struct ipt_entry *)iptc_first_rule (chain, &htable);
> while (entry)
> {
>   rulenum++;
>   if (!(iptc_delete_num_entry (chain, rulenum, &htable)))
>   {
>     printf ("iptc_delete_num_entry: %s\n", iptc_strerror (errno));
>     break;
>   }
> 
>   is_chain_changed = 1;
>   entry = (struct ipt_entry *)iptc_next_rule (entry, &htable);
> }
> 
> if (is_chain_changed)
> {
>   if (!(iptc_commit (&htable)))
>     fprintf (stderr, "iptc_commit: %s\n", iptc_strerror (errno));
> }
> 
> 
> Plus, is the rulenum going to change for the rest of the rules in a chain 
> if I delete a rule? If not immediately, how about after I commit?
> 
> TIA for any help.
> 
> -- 
> Craig Davison
> Symantec Corporation
> +1 (403) 213-3939 ext. 228
> 
-- 
Craig Davison
Symantec Corporation
+1 (403) 213-3939 ext. 228
