From: Jesse Peng <jesse@deansoft.com.tw>
Subject: Re: again!!! the 3rd time, why we need find_appopriate_src? rether
 than just check in_range?
Date: Mon, 08 Dec 2003 16:37:13 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD43839.7080502@deansoft.com.tw>
References: <3FCEBB3C.1000309@deansoft.com.tw> <20031204115945.GE7680@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------010100000800050708090402"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   netfilter
 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------010100000800050708090402
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

  First, very thanx for the reply, it just looks like a dry land finally 
meet some sweet rain drops. But execuse me for the still bother, it 
still remains some unclearing parts.

Harald Welte wrote:

>On Thu, Dec 04, 2003 at 12:42:14PM +0800, Jesse Peng wrote:
>  
>
>>According to above, this circumstance only limited at POST_ROUTING hook, 
>>then the question is as follow:
>>
>>1.Since ip_nat_fn is called both during PREROUTING and POSTROUTING hook, 
>>then we've sure while a new packet passing PREROUTING, the ip_nat_fn 
>>have called ip_nat_rule_find, then the ip_nat_rule_find graranting that 
>>even no rule found the output tuple will be unique(through the 
>>compensation by allocate_null_biding).
>>2.While during POSTROUTE, the input tuple: orig_tuple to 
>>get_unique_tuple is right one the output tuple above mentioned, so it is 
>>still unique!!
>>3.Then why can't we just check if the src of the orig_tuple "in range" 
>>the mr. If it is, then all we need to do is to set the 
>>*tuple=*orig_tuple, and return 1.
>>    
>>
>
>so what about the cases where we have packets originated by the local
>machine?  They will appear via ip_nat_local_fn() -> ip_nat_fn() ->
>ip_nat_rule_find() attached to LOCAL_OUT only if CONFIG_IP_NF_NAT_LOCAL
>is defined.
>
>If not, the packet is actually only seen at POST_ROUTING, and we still
>have to make sure the tuple is unique.
>
1.If the above is true, so the purpose of hash_by_src is only designed 
for local generated packets on the condition with the
CONFIG_IP_NF_NAT_LOCAL not set? and even that, it will mean so far while 
POSTROUTING the nat info not initialized yet, then how can it be 
currently mapped in the hash_by_src hash? as according to the comment:

/* 1) If this srcip/proto/src-proto-part is currently mapped,
	   and that same mapping gives a unique tuple within the given
	   range, use that.

2.I really want to realize  why  hash_by_src, because it's very hard to 
understand the way it prove the uniquity.

3.As you can notice, the partial source I pasted included a  line 
offered by Rusty for fix at NOV. 4, for the convenient, I paste here 
again as below:

if (hooknum == NF_IP_POST_ROUTING) {
       struct ip_conntrack_manip *manip;

       manip = find_appropriate_src(orig_tuple, mr);
       if (manip) {
           /* Apply same source manipulation. */
           *tuple = ((struct ip_conntrack_tuple)
                 { *manip, orig_tuple->dst });
           DEBUGP("get_unique_tuple: Found current src map\n");
           if (!ip_nat_used_tuple(tuple, conntrack)) 
<------------------------------here it is
               return 1;  
       }

and the comment offered by Rusty as below:

ChangeSet@1.497.3182.19 <mailto:ChangeSet@1.497.3182.19>, 2003-11-04 11:32:55-08:00, rusty@rustcorp.com.au <mailto:rusty@rustcorp.com.au>
  [NETFILTER]: get_unique_tuple doesn't always return unique tuple.
  
  get_unique_tuple doesn't check that the tuple is unique if it finds
  a hash_by_src match.

Now I think maybe Rusty's concern is about smp racing,but since even 
hash_by_src also need to face the race, then after some cost effecience 
consider, should'nt the now code look like below?

if (hooknum == NF_IP_POST_ROUTING) {

           /*replace the more cost find_appropriate_src* with simple 
in_range*/
           if ( in_range(orig_tuple, &orig_tuple->src, mr)) {
           /* Apply same source manipulation. */
           *tuple = *orig_tuple;
           DEBUGP("get_unique_tuple: Found current src map\n");
           /*We still have this below protection*/
           if (!ip_nat_used_tuple(tuple, conntrack))
               return 1;
       }
 

>  
>
>>Because this remaining disunderstanding fool me so long and almost
>>destroy my life!!
>>    
>>
>
>it almost destroys yor life?  Is your employer going to fire you if you
>don't understand netfilter code, or what ;) ?
>  
>
hm..Not exactly that!, Just because some projects potentially risk some 
on those complicated. So it's essential to have a good learning on it 
unless I really dare someday being kicked off from my office ;) !

>  
>
>>Your Sincerely
>>    
>>
>
>  
>



--------------010100000800050708090402
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title></title>
</head>
<body>
<title></title>
       First, very thanx for the reply, it just looks like a dry land finally
meet some sweet rain drops. But execuse me for the still bother, it still
remains some unclearing parts.<br>
<br>
 Harald Welte wrote:<br>
 
<blockquote type="cite"
 cite="mid20031204115945.GE7680@obroa-skai.de.gnumonks.org">   
  <pre wrap="">On Thu, Dec 04, 2003 at 12:42:14PM +0800, Jesse Peng wrote:
  </pre>
   
  <blockquote type="cite">     
    <pre wrap="">According to above, this circumstance only limited at POST_ROUTING hook, 
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
    </pre>
   </blockquote>
   
  <pre wrap=""><!---->
so what about the cases where we have packets originated by the local
machine?  They will appear via ip_nat_local_fn() -&gt; ip_nat_fn() -&gt;
ip_nat_rule_find() attached to LOCAL_OUT only if CONFIG_IP_NF_NAT_LOCAL
is defined.

If not, the packet is actually only seen at POST_ROUTING, and we still
have to make sure the tuple is unique.</pre>
 </blockquote>
 1.If the above is true, so the purpose of hash_by_src is only designed for
local generated packets on the condition with the <br>
CONFIG_IP_NF_NAT_LOCAL not set? and even that, it will mean so far while
POSTROUTING the nat info not initialized yet, then how can it be currently
mapped in the hash_by_src hash? as according to the comment:<br>
<pre wrap="">
/* 1) If this srcip/proto/src-proto-part is currently mapped,
	   and that same mapping gives a unique tuple within the given
	   range, use that.</pre>
2.I really want to realize&nbsp; why&nbsp; hash_by_src, because it's very hard to understand
the way it prove the uniquity.<br>
<br>
3.As you can notice, the partial source I pasted included a&nbsp; line offered 
by Rusty for fix at NOV. 4, for the convenient, I paste here again as below:<br>
 <br>
 if (hooknum == NF_IP_POST_ROUTING) { <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct ip_conntrack_manip *manip; <br>
  <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; manip = find_appropriate_src(orig_tuple, mr); <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (manip) { <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Apply same source manipulation. */ <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *tuple = ((struct ip_conntrack_tuple) <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { *manip, orig_tuple-&gt;dst }); <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEBUGP("get_unique_tuple: Found current src map\n"); <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ip_nat_used_tuple(tuple, conntrack)) &lt;------------------------------here 
it is<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 1; &nbsp;<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } <br>
 <br>
 and the comment offered by Rusty as below:<br>
 <br>
 
<pre><a href="mailto:ChangeSet@1.497.3182.19">ChangeSet@1.497.3182.19</a>, 2003-11-04 11:32:55-08:00, <a
 href="mailto:rusty@rustcorp.com.au">rusty@rustcorp.com.au</a>
  [NETFILTER]: get_unique_tuple doesn't always return unique tuple.
  
  get_unique_tuple doesn't check that the tuple is unique if it finds
  a hash_by_src match.</pre>
 Now I think maybe Rusty's concern is about smp racing,but since even hash_by_src
also need to face the race, then after some cost effecience consider, should'nt
the now code look like below?<br>
 <br>
 if (hooknum == NF_IP_POST_ROUTING) {<br>
 <br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;/*replace the more cost find_appropriate_src* with simple in_range*/<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ( in_range(orig_tuple, &amp;orig_tuple-&gt;src, mr)) { <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Apply same source manipulation. */ <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *tuple = *orig_tuple; <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DEBUGP("get_unique_tuple: Found current src map\n"); <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /<b class="moz-txt-star"><span class="moz-txt-tag">*We still
have this below protection</span><span class="moz-txt-tag">*</span></b>/
<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!ip_nat_used_tuple(tuple, conntrack))<br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 1; <br>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; } <br>
 &nbsp;<br>
 <br>
 
<blockquote type="cite"
 cite="mid20031204115945.GE7680@obroa-skai.de.gnumonks.org">   
  <pre wrap="">  </pre>
   
  <blockquote type="cite">     
    <pre wrap="">Because this remaining disunderstanding fool me so long and almost
destroy my life!!
    </pre>
   </blockquote>
   
  <pre wrap=""><!---->
it almost destroys yor life?  Is your employer going to fire you if you
don't understand netfilter code, or what ;) ?
  </pre>
 </blockquote>
 hm..Not exactly that!, Just because some projects potentially risk some
on those complicated. So it's essential to have a good learning on it unless
I really dare someday being kicked off from my office ;) !<br>
 
<blockquote type="cite"
 cite="mid20031204115945.GE7680@obroa-skai.de.gnumonks.org">   
  <pre wrap="">  </pre>
   
  <blockquote type="cite">     
    <pre wrap="">Your Sincerely
    </pre>
   </blockquote>
   
  <pre wrap=""><!---->
  </pre>
 </blockquote>
 <br>
 <br>
 
</body>
</html>

--------------010100000800050708090402--
