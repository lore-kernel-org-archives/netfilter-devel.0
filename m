From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 18:32:42 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020702183242.E7684@oknodo.bof.de>
References: <15643.31140.525551.843205@isis.cs3-inc.com> <20020628082339.I2890@oknodo.bof.de> <15644.41633.528107.723418@isis.cs3-inc.com> <20020628203624.A4136@oknodo.bof.de> <15644.45834.373409.220647@isis.cs3-inc.com> <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>,
	Don Cohen <don-nf@isis.cs3-inc.com>, Patrick Schaaf <bof@bof.de>,
	netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com>; from laforge@gnumonks.org on Tue, Jul 02, 2002 at 04:40:49PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> great. I'd definitley want to encourage the two of you to do some
> furtherr research on the hashing function.

It's good to hear the audience :)

Everybody, have a look at http://bei.bof.de/ex1/. There's a bunch of
pictures, which may become legible together with reading my recent
mails on this thread.

The "cost" listed for each line in each picture, is the sum of the
squares of the bucket list lengths. It's a lame attempt at getting a
single number out of the spread.

The links below the pictures lead you to the bucket statistics
in ASCII text form (output of my cttest program).

The data these pictures are based on, is my sample from some days ago.

Hope this is interesting to somebody :)

best regards
  Patrick
