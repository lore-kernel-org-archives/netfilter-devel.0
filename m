From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Owner match misnaming
Date: Mon, 11 Jul 2005 14:04:38 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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


|OWNER match v1.3.1 options:
|[!] --uid-owner userid     Match local uid
|[!] --gid-owner groupid    Match local gid

After analyzing the kernel part because some packets obviously did not match 
my rules, I notice that these are in reality the socket owner's uid, and not 
the process's uid.

I already started a patch to add process [ug]{,e,s,fs}id to the owner 
kernel and user modules, but according to the comments in the kernel code, 
they would just be as SMP-unsafe as the pid/sid/comm code.

Ideas? Why, after all, is this the case?
BTW,
          /* files->file_lock can not be used in a BH */
a BH is a buffer head, at least in the linux kernel...



Jan Engelhardt                                                               
--                                                                            
