From: "Ramnath R Iyer" <ramnath.r.iyer@gmail.com>
Subject: memory related question w/ netfilter
Date: Sun, 22 Apr 2007 03:00:07 +0530
Message-ID: <ac3a99aa0704211430m7d85d5a7sb3799584d9e5af5f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
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

Hello,

I have a question regarding the way memory works with netfilter. I am
writing a kernel-module that uses netfilter hooks to process certain
kinds of messages.

Suppose my application handles an incoming packet at the
NF_PRE_ROUTING hook. netfilter passes to the input handling function a
/struct sk_buff **/. So suppose I need to queue up the data in the
buffer in my own application, and return NF_STOLEN, which of the
following scenarios is applicable?

(a) The sk_buff memory is subsequently unallocated, so I should copy
the data into a new buffer before returning NF_STOLEN, or

(b) The sk_buff memory remains allocated, so I should call kfree on
the pointer to unallocate it when I'm done using the data, or

(c) Something else

**Please** CC your response directly to me, since I'm not subscribed
to the list. Thank you.

--
Ramnath R Iyer
DA-IICT, India
