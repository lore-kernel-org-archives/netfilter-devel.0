From: Padam J Singh <me@padamj.com>
Subject: New Target related query.
Date: Tue, 28 Sep 2004 17:01:38 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41594B9A.5080201@padamj.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070606060701020208090006"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------070606060701020208090006
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I have written a new iptables target. I followed the regular method of 
registering a new target by the following:


ipt_register_target(...) with a struct like this:
static struct ipt_target ipt_xyz_reg = { { NULL, NULL }, "XYZ", 
ipt_xyz_target, ipt_xyz_checkentry, ipt_xyz_destroy,THIS_MODULE };

 From the userspace, when I create sample rule 1:

iptables -I INPUT -s 172.16.0.1 -j XYZ --param 5
the following functions get called:

ipt_xyz_checkentry. with target info struct populated with 5
the function saves the param in a list and returns 1.


When I create rule 2:
iptables -I INPUT -s 172.16.0.2 -j XYZ --param 6
the following get called:

ipt_xyz_checkentry. with target info struct populated with 6
//the function saves the param in a list and returns 1.

ipt_xyz_checkentry. with target info struct populated with 5
//the function does not save 5 in the list as it already exists and 
returns 1.

ipt_xyz_destroy. with target info struct populated with 5
//the function removes 5 from the list and returns 1.


I was expecting that ipt_xyz_checkentry will be called whenever I create 
a new rule. It seems to call checkentry even for existing rules for 
target XYZ.
I can handle that, however, it also calls destroy, with no user space 
request to delete the rule!

I fail to understand what the issue maybe. How can I stop iptables to 
stop calling the checkentry function for pre-exising rules, and if that 
can't be done, how do i stop it from calling the destroy function on 
it's own.

I am using iptables ver 1.2.11 on kernel 2.4.18-3.


Please help!
Padam Singh.

--------------070606060701020208090006--
