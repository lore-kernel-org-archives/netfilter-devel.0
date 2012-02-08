From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Wed, 8 Feb 2012 01:42:16 +0100
Message-ID: <20120208004216.GC29189@1984>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
 <20120126001928.GA10554@1984>
 <20120126211344.33964cmak17akti0@www.usherbrooke.ca>
 <20120126214641.82372un6d7dcc46c@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab2BHAmU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:42:20 -0500
Content-Disposition: inline
In-Reply-To: <20120126214641.82372un6d7dcc46c@www.usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 26, 2012 at 09:46:41PM -0500, Quentin Aebischer wrote:
> Sorry, forgot to add conntrackd.conf example and README files ...
> 
> From : Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
> 
> Example file conntrackd.conf and README for TIPC implementation of
> the conntrackd daemon.
> 
> Signed-off-by: Quentin Aebischer <quentin.aebischer@usherbrooke.ca>
> ---
>  doc/sync/tipc/README          |   13 ++

I'd appreciate if you can send me a patch for the
doc/manual/conntrack-tools.tmpl instead.

I suggest you to add a small paragraph at "Other configuration
options".

>  doc/sync/tipc/conntrackd.conf |  454
> +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 467 insertions(+), 0 deletions(-)
> 
> diff --git a/doc/sync/tipc/README b/doc/sync/tipc/README
> new file mode 100644
> index 0000000..e7afcc7
> --- /dev/null
> +++ b/doc/sync/tipc/README
> @@ -0,0 +1,13 @@
> +Installation instructions :
> +
> +TIPC is a built-in kernel module since kernel version 2.6.35 ;
> please make sure your using a => 2.6.35 kernel with TIPC 2.0, as
> this patch has not been tested with older versions of the protocol
> yet.
> +
> +For easy and fast configuration, you must install the TIPC utilies
> v2.0.0, available from sources here :
> +
> +    git://tipc.git.sourceforge.net/gitroot/tipc/tipcutils (branch
> tipcutils2.0)
> +
> +or by using aptitude on debian distributions :
> +
> +    sudo apt-get install tipcutils
> +
> +For further details on installation, node and network
> configuration, please refer to the online documentation : http://tipc.sourceforge.net/doc/tipc_2.0_users_guide.html#installation.
> diff --git a/doc/sync/tipc/conntrackd.conf b/doc/sync/tipc/conntrackd.conf
> new file mode 100644
> index 0000000..71946ec
> --- /dev/null
> +++ b/doc/sync/tipc/conntrackd.conf
> @@ -0,0 +1,454 @@
> +#
> +# Synchronizer settings
> +#
> +Sync {
> +	Mode NOTRACK {

Better, add this example to the existing notrack file.

More specifically, this part below just after the commented UDP and
Multicast examples.

> +	TIPC {
> +		#
> +		# Name of the other TIPC port in the cluster (in the form type:instance)

Please, break lines at 80 char, btw.

> +		#
> +		  TIPC_Destination_Name 1000:51
> +
> +		#
> +		# Name of the local TIPC port (used to listen to events)
> +		#
> +		  TIPC_Name 1000:50
> +
> +		#
> +		# The name of the TIPC configured interface that you are going to use
> +		# to send synchronization messages.
> +		#
> +		  Interface eth0
> +
> +		#
> +		# The importance of the TIPC messages sent (the more important
> this is, the more packets will be enabled to queue up on the slave)
> +		# This should be set to High or Critical to avoid congestion on
> the receiver side.
> +		# (possible values : TIPC_LOW_IMPORTANCE, TIPC_MEDIUM_IMPORTANCE,
> TIPC_HIGH_IMPORTANCE, TIPC_CRITICAL_IMPROTANCE)
> +		#
> +		  TIPC_Message_Importance TIPC_CRITICAL_IMPORTANCE
> +
> +		#
> +		# Current TIPC implementation doesnt allow checksumming
> +	}

Thanks Quentin.
