From: "Xiaonan Lu" <zplxn@mail.com>
Subject: Question in install uml-patch-2.4.20-8
Date: Sun, 16 Nov 2003 14:28:27 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031116192827.42820.qmail@mail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
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

Hi, 
I am a new guy to netfilter. I met some problems in my installation of uml. when I type : patch -p0 < uml-patch-2.4.20-8, it runs a little while and show up these error: 
patching file um/arch/um/util/mk_constants_kern.c
patching file um/arch/um/util/mk_constants_user.c
patching file um/arch/um/util/mk_task_kern.c
patching file um/arch/um/util/mk_task_user.c
can't find file to patch at input line 36784
Perhaps you used the wrong -p or --strip option?
The text leading up to this was:
--------------------------
|diff -Naur -X ../exclude-files orig/CREDITS um/CREDITS
|--- orig/CREDITS       2003-02-27 13:04:11.000000000 -0500
|+++ um/CREDITS 2003-02-27 13:05:17.000000000 -0500
--------------------------
File to patch:

I have tried -p1, I got almost the same error. 
What shoudl I do to continue? 

Thanks a lot. 

-- 
__________________________________________________________
Sign-up for your own personalized E-mail at Mail.com
http://www.mail.com/?sr=signup

Search Smarter - get the new eXact Search Bar for free!
http://www.exactsearchbar.com/
