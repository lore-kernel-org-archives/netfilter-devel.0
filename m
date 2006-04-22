From: Patrick Schaaf <bof@bof.de>
Subject: Re: development with queues
Date: Sat, 22 Apr 2006 06:37:05 +0200
Message-ID: <20060422043704.GA780@oknodo.bof.de>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
	<859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
	<a1f5b31e0604181231x69124db5qd6345d544cea9e44@mail.gmail.com>
	<44475817.70100@ufomechanic.net>
	<f015bcab0604200355jfa0756cya5b8248cf6d712bc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: miguel Angel Vazquez <mikinho21@gmail.com>
Content-Disposition: inline
In-Reply-To: <f015bcab0604200355jfa0756cya5b8248cf6d712bc@mail.gmail.com>
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

> In fact we wanted to eliminate the headers oh HTTP because we are
> going to suppose that we have identified all the users profiles( and
> saved in a database owned by a proxy "in the other side of internet")
> and we are going to send to that proxy a simply user identifier.
> 
> Maybe we are not going to eliminate big quantity of information, but
> the UMTS uplink is not quite wide, so it could be interesting.

This stupidity has been tried some years ago. Read about WAP,
visit www.kannel.org for an open source implementation.

The idea is stupid because it's the content, and not the headers,
which consumes bandwidth, unless web SITES are optimized to deliver
very compact content specialized for mobile devices - and then the
win lies in this specialization, and not so much in any header
munging you could reinvent.

best regards
  Patrick
