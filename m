From: Amin Azez <azez@ufomechanic.net>
Subject: ipt_ulog.h versus ebt_ulog.h
Date: Wed, 19 Oct 2005 09:49:01 +0100
Message-ID: <dj519g$ke6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Is there a strong reason why ebt_ulog.h log structure has

       char physindev[IFNAMSIZ];
       char physoutdev[IFNAMSIZ];

and ipt_ulog.h structure does not support physdev?

Also interesting that ebt_ulog has
       struct timeval stamp;

but ipt_ulog has
       long timestamp_sec;
       long timestamp_usec;


I'd like to supply a patch to address these issues for kernel space and
user-space ulog tools, but I am soliciting feedback first.

I think the first addition is more important than the second change.

As a general principle although ebt_* /ipt_* network layer associations
exist, these exist for matching criteria and it seems a bit strong to
assume that just because the selection critera for the -J ULOG target
was impemented in ipt_* or ebt_* that the ULOG reader is not interested
in the entire frame. I mean this only to justify the change. I do also
realise the ulog is to some degree now depracated.

Sam
