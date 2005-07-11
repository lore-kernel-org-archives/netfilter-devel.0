From: Amin Azez <azez@ufomechanic.net>
Subject: Re: Owner match misnaming
Date: Mon, 11 Jul 2005 13:12:52 +0100
Message-ID: <datno8$gft$1@sea.gmane.org>
References: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0507111401170.14796@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Hi,
> 
> 
> |OWNER match v1.3.1 options:
> |[!] --uid-owner userid     Match local uid
> |[!] --gid-owner groupid    Match local gid
> 
> After analyzing the kernel part because some packets obviously did not match 
> my rules, I notice that these are in reality the socket owner's uid, and not 
> the process's uid.
> 
> I already started a patch to add process [ug]{,e,s,fs}id to the owner 
> kernel and user modules, but according to the comments in the kernel code, 
> they would just be as SMP-unsafe as the pid/sid/comm code.
> 
> Ideas? Why, after all, is this the case?
> BTW,
>           /* files->file_lock can not be used in a BH */
> a BH is a buffer head, at least in the linux kernel...

I think BH means bottom-half, referring to the work-side of an
interrupt. I read
http://library.n0i.net/linux-unix/administration/unreliable-guides/kernel-locking/lklockingguide.html
or http://www.kernel.org/pub/linux/kernel/people/rusty/kernel-locking/

They talk about the differnt contraints and BH

Azez
