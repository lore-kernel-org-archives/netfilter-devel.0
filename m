From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [netfilter] 00/29 third try; git-format-patch|git-send-email sucks
Date: Tue, 25 Mar 2008 19:18:57 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, git@vger.kernel.org
To: kaber@trash.net
Return-path: <git-owner@vger.kernel.org>
Sender: git-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


git@ cc'd for justice.

<rants>

  * `git-format-patch --stdout | git-send-email` does not fly,
    files need to be exported first, it's a bit inconvenient

  * git-send-email should really default to --no-chain

  * git-send-email should stop if it cannot find the headers
    it is looking for (esp. Subject), even if I dared to forget --dry-run
    (point in case:  git log -1 mycommit >x.diff; git-send-email x.diff)

</rants>

And now some apology to the mailbomb caused by that program.
