From: Craig Davison <cd@securityfocus.com>
Subject: iptc_delete_entry or iptc_delete_num_entry?
Date: Thu, 30 Jan 2003 19:30:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131023009.GB15989@securityfocus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Should I be using iptc_delete_num_entry or iptc_delete_entry to delete 
rules from a chain? I can't seem to find documentation for the 
parameters of iptc_delete_entry (please point me in the right direction if 
it exists!), and I'm not 100% sure what to pass for the rulenum parameter 
to iptc_delete_num_entry.

The only documentation I have for iptc_delete_num_entry is the 
Querying-libiptc-HOWTO from the LDP, and it says that rulenum is a rule 
number starting at 1 for the first rule.

So let's say I want to delete every rule one at a time from a chain. Do I 
have to manually increase my own rulenum counter for every rule, or is 
there some way to get rulenum from an ipt_entry?

Example:

iptc_handle_t htable;
const char *chain = "INPUT";
struct ipt_entry *entry;
int rulenum = 0, is_chain_changed = 0;

if (!(htable = iptc_init ("filter")))
{
  printf ("iptc_init: %s\n", iptc_strerror (errno));
  exit(0);
}

entry = (struct ipt_entry *)iptc_first_rule (chain, &htable);
while (entry)
{
  rulenum++;
  if (!(iptc_delete_num_entry (chain, rulenum, &htable)))
  {
    printf ("iptc_delete_num_entry: %s\n", iptc_strerror (errno));
    break;
  }

  is_chain_changed = 1;
  entry = (struct ipt_entry *)iptc_next_rule (entry, &htable);
}

if (is_chain_changed)
{
  if (!(iptc_commit (&htable)))
    fprintf (stderr, "iptc_commit: %s\n", iptc_strerror (errno));
}


Plus, is the rulenum going to change for the rest of the rules in a chain 
if I delete a rule? If not immediately, how about after I commit?

TIA for any help.

-- 
Craig Davison
Symantec Corporation
+1 (403) 213-3939 ext. 228
