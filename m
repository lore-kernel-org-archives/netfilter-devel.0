From: JessePeng <jesse@deansoft.com.tw>
Subject: according to 2.4 destroy_conntrack's optimization
Date: Thu, 13 Nov 2003 19:46:24 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FB36F10.2030004@deansoft.com.tw>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------000803080500060309020207"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------000803080500060309020207
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

shoud we add one line to the remove_expectations() as the following:
1.the one line as:
       ip_conntrack_put(ct);

2.the new remove_expectations() as:
static void remove_expectations(struct ip_conntrack *ct)
{
    struct list_head *exp_entry, *next;
    struct ip_conntrack_expect *exp;

    DEBUGP("remove_expectations(%p)\n", ct);

    for (exp_entry = ct->sibling_list.next;
         exp_entry != &ct->sibling_list; exp_entry = next) {
        next = exp_entry->next;
        exp = list_entry(exp_entry, struct ip_conntrack_expect,
                 expected_list);

        /* we skip established expectations, as we want to delete
         * the un-established ones only */
        if (exp->sibling) {
            DEBUGP("remove_expectations: skipping established %p of 
%p\n", exp->sibling, ct);
            /* Indicate that this expectations parent is dead */
            exp->expectant = NULL;

        /* here we let the use -1,otherwise some day the child 
connection die, he'll fail to put his parent's ct use,
         * so I'm afraid that this ct cache will hang forever!!!*/
            ip_conntrack_put(ct); ;-)

            continue;
        }

        IP_NF_ASSERT(list_inlist(&ip_conntrack_expect_list, exp));
        IP_NF_ASSERT(exp->expectant == ct);

        /* delete expectation from global and private lists */
        unexpect_related(exp);
    }
}  

--------------000803080500060309020207
Content-Type: multipart/related;
 boundary="------------070809090804010001080405"


--------------070809090804010001080405
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
shoud we add one line to the remove_expectations() as the following:<br>
1.the one line as:<br>
&nbsp; &nbsp; &nbsp; &nbsp;ip_conntrack_put(ct);<br>
<br>
2.the new remove_expectations() as:<br>
static void remove_expectations(struct ip_conntrack *ct)<br>
{<br>
&nbsp;&nbsp;&nbsp; struct list_head *exp_entry, *next;<br>
&nbsp;&nbsp;&nbsp; struct ip_conntrack_expect *exp;<br>
<br>
&nbsp;&nbsp;&nbsp; DEBUGP("remove_expectations(%p)\n", ct);<br>
<br>
&nbsp;&nbsp;&nbsp; for (exp_entry = ct-&gt;sibling_list.next;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; exp_entry != &amp;ct-&gt;sibling_list; exp_entry = next) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;next = exp_entry-&gt;next;<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;exp = list_entry(exp_entry, struct ip_conntrack_expect,<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp; expected_list);<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;/* we skip established expectations, as we want to delete<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp; * the un-established ones only */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;if (exp-&gt;sibling) {<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;DEBUGP("remove_expectations: skipping established %p of %p\n",
exp-&gt;sibling, ct);<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;/* Indicate that this expectations parent is dead */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;exp-&gt;expectant = NULL;<br>
<br>
&nbsp; &nbsp; &nbsp; &nbsp; /* here we let the use -1,otherwise some day the child connection
die, he'll fail to put his parent's ct use,<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;* so I'm afraid that this ct cache will hang forever!!!*/<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ip_conntrack_put(ct); <img
 src="chrome://editor/content/images/wink_n.gif" alt=";-)"
 class="moz-txt-smily" height="19" width="19" align="middle">
<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;continue; <br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;}<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;IP_NF_ASSERT(list_inlist(&amp;ip_conntrack_expect_list, exp));<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;IP_NF_ASSERT(exp-&gt;expectant == ct);<br>
<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;/* delete expectation from global and private lists */<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; &nbsp;unexpect_related(exp);<br>
&nbsp;&nbsp;&nbsp; }<br>
}&nbsp;&nbsp;
</body>
</html>

--------------070809090804010001080405--

--------------000803080500060309020207--
