From: Jesse Peng <jesse@deansoft.com.tw>
Subject: again!!! the 3rd time, why we need find_appopriate_src? rether than
 just check in_range?
Date: Thu, 04 Dec 2003 12:42:36 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCEBB3C.1000309@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

According to the concerning comments and code within get_unique_tupple 
in ip_nat_core.c, I cite them as below:
/* 1) If this srcip/proto/src-proto-part is currently mapped,
       and that same mapping gives a unique tuple within the given
       range, use that.

       This is only required for source (ie. NAT/masq) mappings.
       So far, we don't do local source mappings, so multiple
       manips not an issue.  */
if (hooknum == NF_IP_POST_ROUTING) {
        struct ip_conntrack_manip *manip;

        manip = find_appropriate_src(orig_tuple, mr);
        if (manip) {
            /* Apply same source manipulation. */
            *tuple = ((struct ip_conntrack_tuple)
                  { *manip, orig_tuple->dst });
            DEBUGP("get_unique_tuple: Found current src map\n");
            if (!ip_nat_used_tuple(tuple, conntrack))
                return 1;
        }

According to above, this circumstance only limited at POST_ROUTING hook, 
then the question is as follow:

1.Since ip_nat_fn is called both during PREROUTING and POSTROUTING hook, 
then we've sure while a new packet passing PREROUTING, the ip_nat_fn 
have called ip_nat_rule_find, then the ip_nat_rule_find graranting that 
even no rule found the output tuple will be unique(through the 
compensation by allocate_null_biding).
2.While during POSTROUTE, the input tuple: orig_tuple to 
get_unique_tuple is right one the output tuple above mentioned, so it is 
still unique!!
3.Then why can't we just check if the src of the orig_tuple "in range" 
the mr. If it is, then all we need to do is to set the 
*tuple=*orig_tuple, and return 1.

So can the new code look like below?

if (hooknum == NF_IP_POST_ROUTING) {
            if ( in_range(orig_tuple, &orig_tuple->src, mr)) {
            /* Apply same source manipulation. */
            *tuple = *orig_tuple;
            DEBUGP("get_unique_tuple: Found current src map\n");
            /*Since we've sure the orig_tuple is unique*/
            /*if (!ip_nat_used_tuple(tuple, conntrack))*/
                return 1;
        }

Ok!!!!May be this doubt is very fool wrong, and  nor the question ever 
exist, Please give me some correct hint.Because this remaining 
disunderstanding fool me so long and almost destroy my life!!

Thanx!! a lot.

Your Sincerely
