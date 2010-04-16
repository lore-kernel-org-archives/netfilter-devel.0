From: Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: "kernel:nf_ct_icmp: bad HW ICMP checksum" too noisy
Date: Fri, 16 Apr 2010 15:36:50 +0200
Message-ID: <m3mxx38qod.fsf@ursa.amorsen.dk>
References: <m31vegztav.fsf@ursa.amorsen.dk> <4BC723EE.9090504@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4BC723EE.9090504@trash.net> (Patrick McHardy's message of "Thu,
	15 Apr 2010 16:34:22 +0200")
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> You should only see that message when nf_conntrack_log_invalid is
> active.

True, I can disable that one as a work-around.


/Benny

