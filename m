From: Patrick Schaaf <bof@bof.de>
Subject: Re: Can  REDIRECT be realized in FORWARD?!
Date: Fri, 28 Mar 2003 11:32:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030328103218.GA32638@oknodo.bof.de>
References: <00ae01c2f50e$77732fa0$5b01aa0a@Dec0y>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Dec0y <anti_decoy@sina.com>
Content-Disposition: inline
In-Reply-To: <00ae01c2f50e$77732fa0$5b01aa0a@Dec0y>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Can  REDIRECT be realized in FORWARD?!

No.

What do you want to accomplish, that you cannot accomplish with
the way things are meant to be?

"I'm in the habit of putting everything into FORWARD" does NOT count.

I doubt that there is any easy, painless way to move REDIRECT
into the filter table. It is designed to be used in the NAT table.

best regards
  Patrick
