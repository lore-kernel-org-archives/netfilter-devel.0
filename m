From: Patrick Schaaf <bof@bof.de>
Subject: Re: Q:how to use another logging facility than "kern"
Date: Sat, 8 Jun 2002 14:23:54 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020608142354.E23410@oknodo.bof.de>
References: <200206081400.31892.uzo@dungeon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: oliver@dungeon.de
Content-Disposition: inline
In-Reply-To: <200206081400.31892.uzo@dungeon.de>; from uzo@dungeon.de on Sat, Jun 08, 2002 at 02:00:31PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> hope this is the right list & you're not annoyed.

As a usage question, the user mailinglist, netfilter@lists.samba.org,
would have been the right place to ask.

> What I am looking for:

> - isn't there a particular piece of code where I can manually change kern to 
> local4 or whatsoever?

Use the --log-level option of the log target.

> - logging the netflter logs to an own file (think it would be a great feature 
> for the LOG target).

Use the ULOG target, and a userspace logging daemon of your liking.

best regards
  Patrick
