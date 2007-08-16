From: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Subject: Locking issue
Date: Thu, 16 Aug 2007 18:54:14 +0100 (BST)
Message-ID: <177537.47029.qm@web7913.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org



Hi there,

This email is regarding ebtables code i.e. bridge
level filtering framework of netfilter. I have sent
this email to ebtables mailing list also but have not
heard from anyone. Hence, am sending this here too. I
hope i will receive some favorable response.

I am new to ebtables code and looking for some help
related to locking and atomicity. I am interested in
looking into the packets intercepted by ebtables,
extract some information, pass this information to
userspace, wait for userspace response and then pass
the result back to ebtable code.

Everything seemed to be working fine until i
encountered locking issues. In the ebt_do_table code
there is a "read_lock_bh" is used. When i try to wait
inside this code path after sending info to my
userspace tool and before returning NF_ACCEPT or
NF_DROP, either the CPU hangs or i get an error
"schedule while atomic". I tried out different methods
for waiting like "wait_event_timeout"  or busy while
loop etc. The problem that I understood is that since
read_lock_bh disables CPU preemption and do
local_bh_disable, if i wait with something that try to
call schedule() I get "schedule while atomic". And, if
i do busy waiting it means am stuck for ever as
preemption is disabled anyways.

It is like chicken and egg problem. I want to wait and
let my userspace process schedule so that I could get
response from it but the code path is atomic so i
cannot schedule my process. After trying out
everything I am clueless as what to do.

Any help in this regard would be appreciated.

Thanks,
Abhinav



      Bollywood, fun, friendship, sports and more. You name it, we have it on http://in.groups.yahoo.com  
