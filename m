From: octane indice <octane@alinto.com>
Subject: Re: firewall with failover - ct_sync ?
Date: Thu, 27 Apr 2006 18:58:14 +0200
Message-ID: <1146157094.4450f8263e46c@webmail.alinto.com>
References: <1145895856.444cfbb0eee53@webmail.alinto.com>
	<20060424164204.GA21760@galois.math.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Maximilian Wilhelm <max@rfc2324.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20060424164204.GA21760@galois.math.uni-paderborn.de>
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

En réponse à Maximilian Wilhelm <max@rfc2324.org> :
> > 1. does ct_sync works?
> 
> Yes, at least for me :)
> 
good :)

> > 2. a) Must I use quilt? 
> 
> quilt does just apply add the patch files listed in the series
> file in the order listed there. You can do this manually if 
> you like (or dislike quilt).
> 
I just don't know quilt. I'll try it.

> > 2. b) Where I grab the patch files?
> 
> For 2.6:
> http://svn.netfilter.org/netfilter/branches/netfilter-ha/
> 
Ok. I have to learn subversion first.
I just know the CVS way or patch way to patch sources.

> (My patches are against the "normal" ct_sync version found in
> the  "linux-2.6" subdirectory of the link above.)
> 
I should patch _two_ times?
Let's take an example:
I download linux-2.6.16, then patch with 
http://svn.netfilter.org/netfilter/branches/netfilter-ha/
then patch with the 
http://vvv.barbarossa.name/files/ct_sync/ct_sync_2.6.16-fix.patch
?

> I did not get the linux-2.6-multigroup stuff running stable
> with the latest kerne up to now. Maybe I'll put my lasting 
> patches for a running-but-unstable-version to the webpage
> these days.
> 
> > 3. Is there another documentation?
> 
> I only know of a german Linux-Magazin article at
> http://www.linux-magazin.de/Artikel/ausgabe/2005/12/linux-ha-fw/linux-ha-
fw.html
>
I don't speak german, I'll try to get it with google translate
 
> > 5. The link beetween the two machines must be an ethernet
> > link? 
> > I have old boxes with two PCI port only, but parrallel link
>>  is OK with plip. 
> 
> ct_sync expects an ethernet interface for syncing.
> You cannot use anything different.
>
PLIP is an ethernet link (sort of). If name "plip" is a 
problem, is there a way to cheat it with udev?
 

> ------------------- Fin du message d'origine ---------------------




"Ce Caillou-là" un conte en téléchargement gratuit sur http://www.Manuscrit.com
