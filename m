From: Patrick Schaaf <bof@bof.de>
Subject: Re: MSN Messenger ALG
Date: Thu, 27 Jun 2002 19:49:14 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020627194913.A2890@oknodo.bof.de>
References: <20020627112623.GD9003@naboo.rchrd.phub.net.cable.rogers.com> <000001c21dfc$3d236890$7200a8c0@blue>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'Amir Khandani' <amirk@broadcom.com>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Glover George <dime@gulfsales.com>
Content-Disposition: inline
In-Reply-To: <000001c21dfc$3d236890$7200a8c0@blue>; from dime@gulfsales.com on Thu, Jun 27, 2002 at 12:01:05PM -0500
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 27, 2002 at 12:01:05PM -0500, Glover George wrote:
> Yes, SIP can get very hairy, because it's primarily xml -ished based.

SIP is very similar to HTTP, and thus any special protocol action would
best be handled by the traditional application level gateway. The REDIRECT
target can be used to transparently address that gateway.

There's no need for any new magic within iptables, I think.

best regards
  Patrick
