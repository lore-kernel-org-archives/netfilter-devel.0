From: "Zheng Chuanbo" <zhengcb@netpower.com.cn>
Subject: What's wrong with the netfilter cvs?
Date: Wed, 17 Nov 2004 08:51:21 +0800
Message-ID: <200411170847164.SM02460@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

Hi,

I tried to checkout the current netfilter code from netfilter cvs server.
But for several days I always failed. And when I tried to browse with web,
It also reported some error. So Is there something wrong with the cvs server?
Or I made some mistake? 

The cvs command I used is as below,

[root@netfilter]# export CVSROOT=:pserver:cvs@pserver.netfilter.org:/cvspublic
[root@netfilter]# cvs login
Logging in to :pserver:cvs@pserver.netfilter.org:2401/cvspublic
CVS password: 
cvs [login aborted]: connect to pserver.netfilter.org(213.95.27.115):2401 failed: Connection refused

Please cc. Thanks.

Regards,
Jack Zheng

zhengcb@netpower.com.cn
