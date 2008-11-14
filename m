From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2 v2] New netfilter target to trigger LED devices
Date: Fri, 14 Nov 2008 08:15:52 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811140802350.1753@fbirervta.pbzchgretzou.qr>
References: <49196D3E.5080305@shikadi.net> <alpine.LNX.1.10.0811131653030.13330@fbirervta.pbzchgretzou.qr> <491CA7A9.9020403@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39956 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNHPz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:15:55 -0500
In-Reply-To: <491CA7A9.9020403@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-13 23:18, Adam Nielsen wrote:
>> > +/*
>> > + * Known issues:
>> > + *
>> > + *  - It's possible to add multiple led triggers with the same name (as
>> > + *    set with --led-trigger-id)
>> > + *
>> > + */
>> 
>> So fix this?
>
> I don't know how :-(  Since the LED hardware class doesn't (to my knowledge)
> allow you to get a list of available LED triggers on the system,

But it may allow you to *test* the presence using something like

checkentry() {
	...
	char buf[];
	strcpy(buf,"netfilter-");
	strcat(buf,name);
	if (led_get(buf) != NULL) {
		printk(KERN_WARNING "That thing already exists\n");
		return false;
	}
	...
}

No? In that case, you could keep a list of names withint he module itself:

struct name_entry {
	struct list_head list;
	char *name;
}
struct list_head known_names;
checkentry() {
	char buf[];
	...
	list_for_each_entry(i, known_names, list)
		if (strcmp(buf, i->name) == 0) {
			printk("that already exists\n");
			return false;
		}
	...
	i = kmalloc(*i, GFP_KERNEL);
	i->name = strdup(buf);
	list_add(&known_names, &i->list);
}

something like that..

> I'd have to
> have some sort of global list that I append to every time a trigger is
> created.  Given the likelihood of this happening (and the fact that it mostly
> works having two triggers with the same name, it just looks bad) I didn't
> think it was important enough for the additional code.

I will let others judge that ;-)

> If this functionality is added to the LED class then I will happily update
> my code to make use of it.

Yeah it would be best if the led class provided something. (preferably
a btree/hashlookup)
