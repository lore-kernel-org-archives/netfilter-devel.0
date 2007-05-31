From: "Tharanga Abeyseela" <tharanga.abeyseela@gmail.com>
Subject: How to pass arguments to a kernel module
Date: Wed, 30 May 2007 21:11:33 -0700
Message-ID: <70309fc20705302111w41c08d91u6c62185d204d41ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Dear all,

I have implemented  a small firewall on linux as a kernel module (.ko)
(using victor castros tutorial on netfilter programming) . and now i
need to pass arguments such as source ip, dst ip, port..etc..from  a
remote machine to my firewall module. basically .ko module should
accept that parameters and block the specific traffic. without
unloading the kernel module how should i insert my firewall  rules to
kernel module.
can someone give me a sample code for that.

many thnaks,

Tharanga
