From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 15:08:18 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507151508060.21786@yvahk01.tjqt.qr>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
	<42D76E84.7080906@fastwebnet.it>
	<Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
	<42D77F23.80403@fastwebnet.it>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: primero <primero@fastwebnet.it>
In-Reply-To: <42D77F23.80403@fastwebnet.it>
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

> if (strcmp(me->version, program_version) != 0) {
> fprintf(stderr, "%s: match `%s' v%s (I'm v%s).\n",
>                       program_name, me->name, me->version, program_version);
>       exit(1);
> }
>
> should return a < 0 value and print the error string ? ... i get a segmentation
> faul instead

You'll get a segfault if "me" is NULL.



Jan Engelhardt
-- 
| Alphagate Systems, http://alphagate.hopto.org/
