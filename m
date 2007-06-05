From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables throws unknown error - suspecting 32/64 compat issue
Date: Tue, 05 Jun 2007 14:16:47 +0200
Message-ID: <4665542F.9020607@trash.net>
References: <Pine.LNX.4.61.0705100812440.32349@yvahk01.tjqt.qr> <200706031047.44848.dim@openvz.org> <4662F2E9.1090903@trash.net> <200706041154.11187.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	sparclinux@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Dmitry Mishin <dim@openvz.org>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <200706041154.11187.dim@openvz.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Dmitry Mishin wrote:
> It's better, but I see the issue with iterate with compat_check_entry() calls.
> If it fails, some of target/matches' check_* functions are called, some not.
> Please, review my version of this patch.


You're right again, thanks. Patch applied.
