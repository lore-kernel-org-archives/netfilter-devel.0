From: Eric Leblond <eleblond@inl.fr>
Subject: Re: using libnetfilter_queue
Date: Fri, 16 Nov 2007 23:14:30 +0100
Message-ID: <1195251270.1167.1.camel@localhost>
References: <20071116210250.GA16546@toroid.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Abhijit Menon-Sen <ams@toroid.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:44922 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935358AbXKPWOf convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:14:35 -0500
In-Reply-To: <20071116210250.GA16546@toroid.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Le samedi 17 novembre 2007 =E0 02:32 +0530, Abhijit Menon-Sen a =E9crit=
 :

> Has anyone written or used, or does anyone know of, applications that
> use libnetfilter_queue to mangle packets in userspace before letting
> them proceed on their way?

Look at snort-inline code:
http://snort-inline.sourceforge.net/

It is able to modify packets in a flow.

BR,
--=20
Eric Leblond <eleblond@inl.fr>
INL

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
