From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Wed, 29 Jun 2005 18:08:01 +0200
Message-ID: <42C2C761.10405@tac.ch>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050629154049.GA17717@oknodo.bof.de>
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

> The problem is compatibility with older versions of the LOG target,
> both Userlevel (iptables .so module), and Kernel.

Fair enough.

> You can either make this a new target, or look how the versioning
> infrastructure discussed here some months ago, worked out. (I don't
> know; maybe there's already a HOWTO, or you want to write one :)

The only reference so far I found is the one about Jamal barking because it hit
his tc baby ;). Are you referring to the sublevel or nested TLVs approach from
netlink?

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
