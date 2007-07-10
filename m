From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: Condition Module (Looking for last version)
Date: Tue, 10 Jul 2007 11:27:02 -0000
Message-ID: <twig.1184066822.88166@bugmachine.ca>
References: <Pine.LNX.4.64.0707100937530.11053@fbirervta.pbzchgretzou.qr>
Reply-To: jix@bugmachine.ca
Cc: netfilter-devel@lists.netfilter.org
To: "Gustavo Jr. Alves" <gjalves@gjalves.com.br>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <13732b70707100130y44ae9f74oe467972d28648906@mail.gmail.com>
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

On Tue, Jul 10, 2007, "Gustavo Jr. Alves" <gjalves@gjalves.com.br> said:

> My concern is about why it hasn´t incorporated on the mainstream
> kernel or not have patches on patch-o-matic.

This patch is part of an external patch-o-matic repository.
All externals patchlets are fetched within POM using `./runme --download`

Take a look at the following file :

(svn) /trunk/patch-o-matic-ng/sources.list

Condition match, as well as many others, are not part of mainstream or POM
because of lack of time/motivation from the Netfilter Core Team to
maintain such patchlets themselves.

See
https://lists.netfilter.org/pipermail/netfilter-devel/2006-April/023927.html

Regards,
Samuel
