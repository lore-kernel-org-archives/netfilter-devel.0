From: "Gerd v. Egidy" <lists@egidy.de>
Subject: condition and 2.6
Date: Sun, 29 Feb 2004 02:10:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402290210.35962.lists@egidy.de>
Reply-To: gerd@egidy.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
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

Hi Harald,

I'm currently using the condition match on a lot of 2.4 machines. I use it to 
differentiate between primary provider/secondary provider, remote 
administration on/off,... 
I like it very much because I don't need to change the rules themselves in a 
live production environment anymore and can therefore make my scripts much 
more rule-independant.

Now I was playing around a bit with 2.6 and found the following comment from 
you in cvs: "made it 2.4.x only, since I don't like it anyway."

What do you dislike? Is it the idea or the implementation? Do you know of any 
bugs or possible problems in the code - especially with 2.6?

Kind regards,

Gerd
