From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: Re: TTL patch buggy?
Date: Tue, 06 Jan 2004 17:18:48 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1073426586.15282.13.camel@jasiiitosh.nexusmgmt.com>
References: <1073055732.2995.4.camel@jasiiitosh.nexusmgmt.com>
	 <20040106185613.GB934@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040106185613.GB934@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ugh!! I'll have to see if I can find it.  I'm sure I deleted it.  It was
just an obscure reference to a bug in TTL but was not specific.  We are
planning to not only use the TTL patch in ISCS to create stealth
firewalls but also to secure communications between internal and DMZ
systems by allowing admins to set TTL on a per service basis to allow
the DMZ <-> Internal flow to only have enough life to live on the site
and not to be set anywhere else on the Internet.  We think this is a
pretty interesting feature and hence are keen on the TTL patch working. 
Thanks for the update - John

On Tue, 2004-01-06 at 13:56, Harald Welte wrote:
> On Fri, Jan 02, 2004 at 10:02:13AM -0500, John A. Sullivan III wrote:
> > I noticed a recent post on the netfilter list about the TTL patch
> > being buggy.  
> 
> Could you please point me to that posting (either message-id or a URL
> pointing to the archives?)
> 
> > We were planning to make extensive use of it in the ISCS
> > project.  I've not seen anything recent about such a bug in a google
> > search.  Is there currently a known problem with this patch? Thanks -
> 
> I (the author) am not aware of any current problem.
> 
> If there are bugs/problems, they should be submitted to
> bugzilla.netfilter.org
> 
> > John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
