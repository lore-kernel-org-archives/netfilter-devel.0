From: Patrick McHardy <kaber@trash.net>
Subject: Re: Raw Sockets and Netfiter
Date: Tue, 25 Mar 2003 10:11:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E801D44.8020409@trash.net>
References: <001701c2f29d$20afe1e0$6b01a8c0@COURVOISIER> <20030325072544.GI18652@oknodo.bof.de> <3E800DE4.9070000@trash.net> <20030325081216.GJ18652@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ethan Dameron <efd@duke.edu>
In-Reply-To: <20030325081216.GJ18652@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Ethan,
looks like good news:

ipt_hook: happy cracking.
ipt_hook: happy cracking.
ipt_hook: happy cracking.
ipt_tcpmss_target: bad length (10 bytes)

So your packets will traverse iptables.
Bye,
Patrick
